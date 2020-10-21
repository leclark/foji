// Code generated by foji 0.3, template: foji/openapi/auth.go.tpl; DO NOT EDIT.

package http

import (
	"bytes"
	"encoding/base64"

	"github.com/bir/iken/fastutil"
	"github.com/gofoji/foji/test"
	"github.com/valyala/fasthttp"
)

// HttpAuthFunc is the signature of a function used to authenticate an http request.
// Given a request, it returns the authenticated user.  If unable to authenticate the
// request it returns an error.
type HttpAuthFunc = func(ctx *fasthttp.RequestCtx) (*test.User, error)

// Authenticator takes a key (for example a bearer token) and returns the authenticated user.
type Authenticator = func(key string) (*test.User, error)

// BasicAuthenticator takes a user/pass pair and returns the authenticated user.
type BasicAuthenticator = func(user, pass string) (*test.User, error)

var (
	basicAuthPrefix = []byte("Basic ")
)

// AAuth is responsible for extracting "a" credentials from a request and calling the
// supplied Authenticator to authenticate
//
func AAuth(fn BasicAuthenticator) HttpAuthFunc {
	return func(ctx *fasthttp.RequestCtx) (*test.User, error) {
		b := ctx.Request.Header.Peek("Authorization")
		if len(b) == 0 {
			return nil, fastutil.ErrBasicAuthenticate
		}

		payload, err := base64.StdEncoding.DecodeString(string(b[len(basicAuthPrefix):]))
		if err != nil {
			return nil, fastutil.ErrUnauthorized
		}

		pair := bytes.SplitN(payload, []byte(":"), 2)
		if len(pair) != 2 {
			return nil, fastutil.ErrUnauthorized
		}

		return fn(string(pair[0]), string(pair[1]))
	}
}
