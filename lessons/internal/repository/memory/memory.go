package memory

import (
	"context"
	"github.com/EliriaT/school-api/lessons/internal/repository"
	"github.com/EliriaT/school-api/lessons/pkg/model"
)

type Repository struct {
	data map[model.CourseID]*model.Course
}

func New() *Repository {
	return &Repository{map[model.CourseID]*model.Course{}}
}

func (r *Repository) Get(ctx context.Context, courseID model.CourseID) (*model.Course, error) {
	if _, ok := r.data[courseID]; !ok {
		return nil, repository.ErrNotFound
	}

	if _, ok := r.data[courseID]; !ok {
		return nil, repository.ErrNotFound
	}
	return r.data[courseID], nil
}

func (r *Repository) Put(ctx context.Context, courseID model.CourseID, course *model.Course) error {
	r.data[courseID] = course
	return nil
}
