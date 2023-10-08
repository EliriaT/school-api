package memory

import (
	"context"
	"github.com/EliriaT/school-api/school/internal/repository"
	"github.com/EliriaT/school-api/school/pkg/model"
	"sync"
)

// Repository defines a memory movie matadata repository.
type Repository struct {
	sync.RWMutex
	data map[string]*model.School
}

// New creates a new memory repository.
func New() *Repository {
	return &Repository{data: map[string]*model.School{}}
}

// Get retrieves movie metadata for by movie id.
func (r *Repository) Get(_ context.Context, id string) (*model.School, error) {
	r.RLock()
	defer r.RUnlock()
	m, ok := r.data[id]
	if !ok {
		return nil, repository.ErrNotFound
	}
	return m, nil
}

// Put adds movie metadata for a given movie id.
func (r *Repository) Put(_ context.Context, id string, metadata *model.School) error {
	r.Lock()
	defer r.Unlock()
	r.data[id] = metadata
	return nil
}
