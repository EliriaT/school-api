package auth

import (
	"errors"
	"github.com/EliriaT/school-api/school/pkg/models"
	"github.com/golang-jwt/jwt"
	"time"
)

var (
	ErrInvalidToken    = errors.New("token is invalid")
	ErrExpiredToken    = errors.New("token has expired")
	ErrGeneratingToken = errors.New("token could not be signed")
)

type JwtWrapper struct {
	SecretKey       string
	Issuer          string
	ExpirationHours int64
}

type jwtClaims struct {
	jwt.StandardClaims
	Id       int64
	Email    string
	SchoolId int64
	ClassId  int64
	RoleId   int64
}

func (w *JwtWrapper) GenerateToken(user models.User) (signedToken string, err error) {
	claims := &jwtClaims{
		Id:       user.ID,
		Email:    user.Email,
		SchoolId: user.SchoolId,
		RoleId:   user.RoleId,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: time.Now().Local().Add(time.Hour * time.Duration(w.ExpirationHours)).Unix(),
			Issuer:    w.Issuer,
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	signedToken, err = token.SignedString([]byte(w.SecretKey))

	if err != nil {
		return "", ErrGeneratingToken
	}

	return signedToken, nil
}

func (w *JwtWrapper) ValidateToken(signedToken string) (claims *jwtClaims, err error) {
	token, err := jwt.ParseWithClaims(
		signedToken,
		&jwtClaims{},
		func(token *jwt.Token) (interface{}, error) {
			return []byte(w.SecretKey), nil
		},
	)

	if err != nil {
		if ve, ok := err.(*jwt.ValidationError); ok {
			if ve.Errors&jwt.ValidationErrorExpired != 0 {
				return nil, ErrExpiredToken
			}
		}
		return nil, ErrInvalidToken
	}

	claims, ok := token.Claims.(*jwtClaims)

	if !ok {
		return nil, ErrInvalidToken
	}

	if claims.ExpiresAt < time.Now().Local().Unix() {
		return nil, ErrExpiredToken
	}

	return claims, nil
}
