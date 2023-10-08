package school

import (
	"context"
	"errors"
	"github.com/EliriaT/school-api/school/internal/db"
	"github.com/EliriaT/school-api/school/pkg/models"
)

var ErrNotFound = errors.New("not found")

type schoolRepository interface {
	Get(ctx context.Context, id string) (*models.School, error)
}

type Controller struct {
	repo schoolRepository
}

func New(repo schoolRepository) *Controller {
	return &Controller{repo}
}

func (c *Controller) Get(ctx context.Context, id string) (*models.School, error) {
	res, err := c.repo.Get(ctx, id)
	if err != nil && errors.Is(err, db.ErrNotFound) {
		return nil, ErrNotFound
	}
	return res, err
}
