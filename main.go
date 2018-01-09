package main

import (
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/jrantamaki/supertimemachine/model"
	"strconv"
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

	// example on how to serve json...
	router.GET("/entry/:id", func(c *gin.Context){
		id :=  c.Param("id")
		i, err := strconv.Atoi(id)

		if err != nil { //FIXME there must be a better way to validate the parameter, that it is an int.
			c.JSON(http.StatusBadRequest, "id must be a number");
			return;
		}
		if i == 1 {
			c.JSON(http.StatusOK, testEntry);
		} else if i == 2 {
			c.JSON(http.StatusOK, anotherTestEntry);
		} else {
			c.JSON(http.StatusNotFound, model.TimeEntry{""});
		}
	})

	router.Run(":" + port)
}
