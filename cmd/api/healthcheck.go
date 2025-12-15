package main

import (
	"net/http"
)

// healthcheckHandler обрабатывает запрос о состоянии сервера.
// в ответе возвращает JSON с данными о текущем окружении и версии сервера.
func (app *application) healthcheckHandler(w http.ResponseWriter, r *http.Request) {
	env := envelope{
		"status": "available",
		"system_info": map[string]string{
			"environment": app.config.env,
			"version":     version,
		},
	}

	err := app.writeJSON(w, http.StatusOK, env, nil)
	if err != nil {
		app.serverErrorResponse(w, r, err)
	}
}
