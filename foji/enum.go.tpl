// Code generated by foji {{ version }}, template: {{ templateFile }}; DO NOT EDIT.

package {{ .PackageName }}

import (
	"database/sql/driver"
	"fmt"

{{- range .Imports }}
	"{{ . }}"
{{- end }}

)

{{- $type := case .Enum.Name }}

// {{ $type }} is the '{{ .Enum.Name }}' enum type from schema '{{ .Enum.Schema.Name  }}'.
type {{ $type }} uint16

const (
	// Unknown{{$type}} defines an invalid {{$type}}.
	Unknown{{$type}} {{$type}} = iota
{{- range .Enum.Values }}
	{{ case . }}{{ $type }}
{{- end }}
)

// String returns the string value of the {{ $type }}.
func (e {{ $type }}) String() string {
	switch e {
{{- range .Enum.Values }}
	case {{ case . }}{{ $type }}:
		return "{{ . }}"
{{- end }}
	default:
		return "Unknown{{$type}}"
	}
}

// MarshalText marshals {{ $type }} into text.
func (e {{ $type }}) MarshalText() ([]byte, error) {
	return []byte(e.String()), nil
}

// UnmarshalText unmarshals {{ $type }} from text.
func (e *{{ $type }}) UnmarshalText(text []byte) error {
	val, err := Parse{{$type}}(string(text))
	if err != nil {
		return err
	}
	*e = val
	return nil
}

// Parse{{$type}} converts s into a {{$type}} if it is a valid
// stringified value of {{$type}}.
func Parse{{$type}}(s string) ({{$type}}, error) {
	switch s {
{{- range .Enum.Values }}
	case "{{ . }}":
		return {{ case . }}{{ $type }}, nil
{{- end }}
	default:
		return Unknown{{$type}}, fmt.Errorf("invalid {{ $type }}")
	}
}

// Value satisfies the sql/driver.Valuer interface for {{ $type }}.
func (e {{ $type }}) Value() (driver.Value, error) {
	return e.String(), nil
}

// Scan satisfies the database/sql.Scanner interface for {{ $type }}.
func (e *{{ $type }}) Scan(src interface{}) error {
	buf, ok := src.([]byte)
	if !ok {
		return errors.New("invalid {{ $type }}")
	}

	return e.UnmarshalText(buf)
}

// {{$type}}Field is a component that returns a {{ $.PackageName }}.Where that contains a
// comparison based on its field and a strongly typed value.
type {{$type}}Field string

// Equals returns a {{$.PackageName}}.WhereClause for this field.
func (f {{$type}}Field) Equals(v {{$type}}) {{$.PackageName}}.Where {
	return {{$.PackageName}}.Where{
		Field: string(f),
		Comp:  {{$.PackageName}}.CompEqual,
		Value: v,
	}
}

// GreaterThan returns a {{$.PackageName}}.Where for this field.
func (f {{$type}}Field) GreaterThan(v {{$type}}) {{$.PackageName}}.Where {
	return {{$.PackageName}}.Where{
		Field: string(f),
		Comp:  {{$.PackageName}}.CompGreater,
		Value: v,
	}
}

// LessThan returns a {{$.PackageName}}.Where for this field.
func (f {{$type}}Field) LessThan(v {{$type}}) {{$.PackageName}}.Where {
	return {{$.PackageName}}.Where{
		Field: string(f),
		Comp:  {{$.PackageName}}.CompEqual,
		Value: v,
	}
}

// GreaterOrEqual returns a {{$.PackageName}}.Where for this field.
func (f {{$type}}Field) GreaterOrEqual(v {{$type}}) {{$.PackageName}}.Where {
	return {{$.PackageName}}.Where{
		Field: string(f),
		Comp:  {{$.PackageName}}.CompGTE,
		Value: v,
	}
}

// LessOrEqual returns a {{$.PackageName}}.Where for this field.
func (f {{$type}}Field) LessOrEqual(v {{$type}}) {{$.PackageName}}.Where {
	return {{$.PackageName}}.Where{
		Field: string(f),
		Comp:  {{$.PackageName}}.CompLTE,
		Value: v,
	}
}

// NotEqual returns a {{$.PackageName}}.Where for this field.
func (f {{$type}}Field) NotEqual(v {{$type}}) {{$.PackageName}}.Where {
	return {{$.PackageName}}.Where{
		Field: string(f),
		Comp:  {{$.PackageName}}.CompNE,
		Value: v,
	}
}

// In returns a {{$.PackageName}}.Where for this field.
func (f {{$type}}Field) In(vals []{{$type}}) {{$.PackageName}}.InClause {
	values := make([]interface{}, len(vals))
	for x := range vals {
		values[x] = vals[x]
	}
	return {{$.PackageName}}.InClause{
		Field: string(f),
		Vals:  values,
	}
}
