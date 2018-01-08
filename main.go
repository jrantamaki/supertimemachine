package main

import (
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/jrantamaki/supertimemachine/model"
)

func main() {
	port := os.Getenv("PORT")

	if port == "" {
		log.Fatal("$PORT must be set")
	}

	router := gin.New()
	router.Use(gin.Logger())
	router.LoadHTMLGlob("templates/*.tmpl.html")
	router.Static("/static", "static")

	router.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.tmpl.html", nil)
	})

	testEntry := model.TimeEntry{Description:"My Test Time Entry Here."}
	anotherTestEntry := model.TimeEntry{Description:"Just messing with the project structure"}

	log.Print("Hello ",  testEntry.Description)
	log.Print("Hello Again and more. ",  anotherTestEntry.Description)

	router.Run(":" + port)
}
