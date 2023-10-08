package school

import (
	"context"
	"errors"
	"github.com/EliriaT/school-api/school/internal/repository"
	"github.com/EliriaT/school-api/school/pkg/model"
)

var ErrNotFound = errors.New("not found")

type schoolRepository interface {
	Get(ctx context.Context, id string) (*model.School, error)
}

type Controller struct {
	repo schoolRepository
}

func New(repo schoolRepository) *Controller {
	return &Controller{repo}
}

func (c *Controller) Get(ctx context.Context, id string) (*model.School, error) {
	res, err := c.repo.Get(ctx, id)
	if err != nil && errors.Is(err, repository.ErrNotFound) {
		return nil, ErrNotFound
	}
	return res, err
}
