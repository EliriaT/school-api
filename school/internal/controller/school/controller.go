package school

import (
	"context"
	"errors"
	"github.com/EliriaT/school-api/school/internal/repository"
	"github.com/EliriaT/school-api/school/pkg/model"
)

// ErrNotFound is returned when a requested record is not found.
var ErrNotFound = errors.New("not found")

type schoolRepository interface {
	Get(ctx context.Context, id string) (*model.School, error)
}

// Controller defines a school service controller.
type Controller struct {
	repo schoolRepository
}

// New creates a school service controller.
func New(repo schoolRepository) *Controller {
	return &Controller{repo}
}

// Get returns movie metadata by id.
func (c *Controller) Get(ctx context.Context, id string) (*model.School, error) {
	res, err := c.repo.Get(ctx, id)
	if err != nil && errors.Is(err, repository.ErrNotFound) {
		return nil, ErrNotFound
	}
	return res, err
}
