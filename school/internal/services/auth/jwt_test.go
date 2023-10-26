package auth

import (
	"github.com/EliriaT/school-api/school/internal/services/seed"
	"github.com/EliriaT/school-api/school/pkg/models"
	"github.com/golang-jwt/jwt"
	"github.com/stretchr/testify/require"
	"testing"
	"time"
)

func TestJWTMaker(t *testing.T) {
	var duration int64 = 1
	maker := JwtWrapper{SecretKey: seed.RandomString(32),
		Issuer:          seed.RandomString(5),
		ExpirationHours: duration}

	userId := seed.RandomInt(1, 10)
	email := seed.RandomEmail()
	password := seed.RandomString(10)
	hashedPassword1, err := HashPassword(password)
	schoolId := seed.RandomInt(1, 10)
	roleId := seed.RandomInt(1, 10)
	require.NoError(t, err)

	issuedAt := time.Now()
	expiredAt := issuedAt.Add(time.Hour * 1)

	user := models.User{
		ID:       userId,
		Email:    email,
		Password: hashedPassword1,
		Name:     seed.RandomString(10),
		SchoolId: schoolId,
		RoleId:   roleId,
		School:   models.School{},
	}

	token, err := maker.GenerateToken(user)
	require.NoError(t, err)
	require.NotEmpty(t, token)

	payload, err := maker.ValidateToken(token)
	require.NoError(t, err)
	require.NotEmpty(t, payload)

	require.NotZero(t, payload.Id)
	require.Equal(t, email, payload.Email)
	require.Equal(t, schoolId, payload.SchoolId)
	require.Equal(t, roleId, payload.RoleId)
	require.WithinDuration(t, expiredAt, time.Unix(payload.ExpiresAt, 0), time.Second)
}

func TestExpiredJWTToken(t *testing.T) {
	var duration int64 = 1
	maker := JwtWrapper{SecretKey: seed.RandomString(32),
		Issuer:          seed.RandomString(5),
		ExpirationHours: -duration}

	userId := seed.RandomInt(1, 10)
	email := seed.RandomEmail()
	password := seed.RandomString(10)
	hashedPassword1, err := HashPassword(password)
	schoolId := seed.RandomInt(1, 10)
	roleId := seed.RandomInt(1, 10)
	require.NoError(t, err)

	user := models.User{
		ID:       userId,
		Email:    email,
		Password: hashedPassword1,
		Name:     seed.RandomString(10),
		SchoolId: schoolId,
		RoleId:   roleId,
		School:   models.School{},
	}

	token, err := maker.GenerateToken(user)
	require.NoError(t, err)
	require.NotEmpty(t, token)

	payload, err := maker.ValidateToken(token)

	require.Error(t, err)
	require.EqualError(t, err, ErrExpiredToken.Error())
	require.Nil(t, payload)
}

func TestInvalidJWTTokenAlgNone(t *testing.T) {
	userId := seed.RandomInt(1, 10)
	email := seed.RandomEmail()
	password := seed.RandomString(10)
	hashedPassword1, err := HashPassword(password)
	schoolId := seed.RandomInt(1, 10)
	roleId := seed.RandomInt(1, 10)
	issuer := seed.RandomString(5)
	expirationHours := 1
	require.NoError(t, err)

	user := models.User{
		ID:       userId,
		Email:    email,
		Password: hashedPassword1,
		Name:     seed.RandomString(10),
		SchoolId: schoolId,
		RoleId:   roleId,
		School:   models.School{},
	}
	claims := &jwtClaims{
		Id:       user.ID,
		Email:    user.Email,
		SchoolId: user.SchoolId,
		RoleId:   user.RoleId,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: time.Now().Local().Add(time.Hour * time.Duration(expirationHours)).Unix(),
			Issuer:    issuer,
		},
	}

	jwtToken := jwt.NewWithClaims(jwt.SigningMethodNone, claims)
	token, err := jwtToken.SignedString(jwt.UnsafeAllowNoneSignatureType)
	require.NoError(t, err)

	maker := JwtWrapper{SecretKey: seed.RandomString(32),
		Issuer:          seed.RandomString(5),
		ExpirationHours: int64(expirationHours)}

	payload, err := maker.ValidateToken(token)
	require.Error(t, err)
	require.EqualError(t, err, ErrInvalidToken.Error())
	require.Nil(t, payload)
}
