package main

import (
	"fmt"
	"net/http"
)

// В этом файле определены вспомогательные функции для обработки ошибок HTTP.
// Функции logError и errorResponse составляют базовый уровень:
// logError протоколирует ошибку, а errorResponse формирует и отправляет JSON-ответ.
// На их основе построены более конкретные функции, которые генерируют стандартные
// JSON-ответы для различных типов ошибок (400, 401, 403, 404 и т. д.).
// В обработчиках рекомендуется использовать именно эти специализированные функции.

// logError извлекает из запроса r метод и URI
// и логирует их вместе с ошибкой
func (app *application) logError(r *http.Request, err error) {
	var (
		method = r.Method
		uri    = r.URL.RequestURI()
	)

	app.logger.Error(err.Error(), "method", method, "uri", uri)
}

// errorResponse формирует JSON-ответ с описанием ошибки
// и отправляет клиенту. Используется для единообразной обработки ошибок.
func (app *application) errorResponse(w http.ResponseWriter, r *http.Request, status int, message any) {
	env := envelope{"error": message}

	err := app.writeJSON(w, status, env, nil)
	if err != nil {
		app.logError(r, err)
		w.WriteHeader(500)
	}
}

// serverErrorResponse отправляет стандартный JSON-ответ
// об ошибке 500
func (app *application) serverErrorResponse(w http.ResponseWriter, r *http.Request, err error) {
	app.logError(r, err)

	message := "the server encountered a problem and could not process your request"
	app.errorResponse(w, r, http.StatusInternalServerError, message)
}

// notFoundResponse отправляет стандартный JSON-ответ
// об ошибке 404
func (app *application) notFoundResponse(w http.ResponseWriter, r *http.Request) {
	message := "the requested resource could not be found"
	app.errorResponse(w, r, http.StatusNotFound, message)
}

// methodNotAllowedResponse отправляет стандартный JSON-ответ
// об ошибке 405
func (app *application) methodNotAllowedResponse(w http.ResponseWriter, r *http.Request) {
	message := fmt.Sprintf("the %s method is not supported for this resource", r.Method)
	app.errorResponse(w, r, http.StatusMethodNotAllowed, message)
}

// badRequestResponse отправляет стандартный JSON-ответ
// об ошибке 400
func (app *application) badRequestResponse(w http.ResponseWriter, r *http.Request, err error) {
	app.errorResponse(w, r, http.StatusBadRequest, err.Error())
}

// editConflictResponse отправляет стандартный JSON-ответ
// об ошибке 409 (конфликт при изменении ресурса)
func (app *application) editConflictResponse(w http.ResponseWriter, r *http.Request) {
	message := "unable to update the record due to an edit conflict, please try again"
	app.errorResponse(w, r, http.StatusConflict, message)
}

// rateLimitExceededResponse отправляет стандартный JSON-ответ
// об ошибке 429 (слишком много запросов в единицу времени)
func (app *application) rateLimitExceededResponse(w http.ResponseWriter, r *http.Request) {
	message := "rate limit exceeded"
	app.errorResponse(w, r, http.StatusTooManyRequests, message)
}

// invalidCredentialsResponse отправляет стандартный JSON-ответ
// об ошибке 401 (неправильные логин или пароль)
func (app *application) invalidCredentialsResponse(w http.ResponseWriter, r *http.Request) {
	message := "invalid authentication credentials"
	app.errorResponse(w, r, http.StatusUnauthorized, message)
}

// invalidAuthenticationTokenResponse отправляет стандартный
// JSON-ответ об ошибке 401 (токен отсутствует, невалиден или испорчен)
func (app *application) invalidAuthenticationTokenResponse(w http.ResponseWriter, r *http.Request) {
	message := "invalid or missing authentication token"
	app.errorResponse(w, r, http.StatusUnauthorized, message)
}

// authenticationRequiredResponse отправляет стандартный JSON-ответ
// об ошибке 401 (доступ без аутенификации запрещен)
func (app *application) authenticationRequiredResponse(w http.ResponseWriter, r *http.Request) {
	message := "you must be authenticated to access this resource"
	app.errorResponse(w, r, http.StatusUnauthorized, message)
}

// inactiveAccountResponse отправляет стандартный JSON-ответ
// об ошибке 403 (аккаунт не активирован)
func (app *application) inactiveAccountResponse(w http.ResponseWriter, r *http.Request) {
	message := "your user account must be activated to access this resource"
	app.errorResponse(w, r, http.StatusForbidden, message)
}

// notPermittedResponse отправляет стандартный JSON-ответ
// об ошибке 403 (аккаунт не имеет прав для доступа к ресурсу)
func (app *application) notPermittedResponse(w http.ResponseWriter, r *http.Request) {
	message := "your user account doesn't have the neccessary permissions to access this resource"
	app.errorResponse(w, r, http.StatusForbidden, message)
}

// failedValidationResponse отправляет стандартный JSON-ответ
// об ошибке 422 (ошибка валидации)
func (app *application) failedValidationResponse(w http.ResponseWriter, r *http.Request, errors map[string]string) {
	app.errorResponse(w, r, http.StatusUnprocessableEntity, errors)
}
