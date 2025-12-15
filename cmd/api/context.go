package main

import (
	"context"
	"net/http"

	"github.com/olegmif/greenlight/internal/data"
)

// функции для работы с контекстом запроса.

// contextKey — тип ключа для хранения значений в контексте.
// Используется, чтобы избежать конфликтов ключей между пакетами.
type contextKey string

const userContextKey = contextKey("user")

// contextSetUser добавляет пользователя user в контекст запроса r,
// и возвращает новый запрос с обновленным контекстом.
func (app *application) contextSetUser(r *http.Request, user *data.User) *http.Request {
	ctx := context.WithValue(r.Context(), userContextKey, user)
	return r.WithContext(ctx)
}

// contextGetUser извлекает пользователя из контекста запроса r.
// Если пользователь отсутствует в контексте, функция вызывает панику.
func (app *application) contextGetUser(r *http.Request) *data.User {
	user, ok := r.Context().Value(userContextKey).(*data.User)
	if !ok {
		panic("missing user value in request context")
	}

	return user
}
