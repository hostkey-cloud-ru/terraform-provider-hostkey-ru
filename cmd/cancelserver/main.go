package main

import (
	"context"
	"fmt"
	"os"
	"strconv"

	"github.com/hostkey-cloud-ru/terraform-provider-hostkey-ru/internal/invapi"
)

// Immediate WHMCS cancellation for one or more InvAPI server ids.
//
//	HOSTKEY_API_KEY=… go run ./cmd/cancelserver 23383
func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "usage: go run ./cmd/cancelserver <server-id> [server-id...]")
		os.Exit(2)
	}
	apiKey := os.Getenv("HOSTKEY_API_KEY")
	if apiKey == "" {
		fmt.Fprintln(os.Stderr, "HOSTKEY_API_KEY is required")
		os.Exit(1)
	}
	c, err := invapi.NewClient(invapi.Config{BaseURL: invapi.DefaultBaseURL}, nil)
	if err != nil {
		fail(err)
	}
	auth := invapi.NewTokenManager(apiKey, 3600, c)
	c.SetAuth(auth)
	if _, err := auth.Token(context.Background()); err != nil {
		fail(err)
	}
	imm := 1
	failed := false
	for _, a := range os.Args[1:] {
		id, err := strconv.Atoi(a)
		if err != nil {
			fmt.Fprintf(os.Stderr, "bad id %q: %v\n", a, err)
			failed = true
			continue
		}
		if id == 56909 {
			fmt.Fprintln(os.Stderr, "refusing banned server id 56909")
			failed = true
			continue
		}
		if err := c.WHMCSRequestCancellation(context.Background(), id, "terraform destroy", &imm); err != nil {
			fmt.Printf("cancel %d: ERROR %v\n", id, err)
			failed = true
			continue
		}
		fmt.Printf("cancel %d: OK\n", id)
	}
	if failed {
		os.Exit(1)
	}
}

func fail(err error) {
	fmt.Fprintln(os.Stderr, err)
	os.Exit(1)
}
