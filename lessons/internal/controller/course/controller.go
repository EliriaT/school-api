package course

import (
	"context"
	"errors"
	"github.com/EliriaT/school-api/lessons/internal/repository"
	"github.com/EliriaT/school-api/lessons/pkg/model"
)

var ErrNotFound = errors.New("course not found")

type courseRepository interface {
	Get(ctx context.Context, courseID model.CourseID) (*model.Course, error)
	Put(ctx context.Context, courseID model.CourseID, course *model.Course) error
}

type Controller struct {
	repo courseRepository
}

func New(repo courseRepository) *Controller {
	return &Controller{repo}
}

func (c *Controller) GetCourse(ctx context.Context, courseID model.CourseID) (*model.Course, error) {
	res, err := c.repo.Get(ctx, courseID)
	if err != nil && errors.Is(err, repository.ErrNotFound) {
		return nil, ErrNotFound
	}
	return res, err
}

func (c *Controller) PutCourse(ctx context.Context, courseID model.CourseID, course *model.Course) error {
	return c.repo.Put(ctx, courseID, course)
}
