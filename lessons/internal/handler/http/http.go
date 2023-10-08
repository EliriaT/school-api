package http

import (
	"encoding/json"
	"errors"
	"github.com/EliriaT/school-api/lessons/internal/controller/course"
	"github.com/EliriaT/school-api/lessons/pkg/model"
	"log"
	"net/http"
	"strconv"
)

type Handler struct {
	ctrl *course.Controller
}

// New creates a new rating service HTTP handler.
func New(ctrl *course.Controller) *Handler {
	return &Handler{ctrl}
}

// Handle handles PUT and GET /rating requests.
func (h *Handler) Handle(w http.ResponseWriter, req *http.Request) {
	id, err := strconv.Atoi(req.FormValue("id"))
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}
	courseID := model.CourseID(id)

	switch req.Method {
	case http.MethodGet:
		v, err := h.ctrl.GetCourse(req.Context(), courseID)
		if err != nil && errors.Is(err, course.ErrNotFound) {
			w.WriteHeader(http.StatusNotFound)
			return
		}
		if err := json.NewEncoder(w).Encode(v); err != nil {
			log.Printf("Response encode error: %v\n", err)
		}
	case http.MethodPut:

		if err := h.ctrl.PutCourse(req.Context(), courseID, &model.Course{}); err != nil {
			log.Printf("Repository put error: %v\n", err)
			w.WriteHeader(http.StatusInternalServerError)
		}
	default:
		w.WriteHeader(http.StatusBadRequest)
	}
}
