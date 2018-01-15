package main

import (
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"strconv"
	"supertimemachine/model"
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
		c.File("static/index.html")
	})


	testEntry := model.Task{Description:"My Test Time Entry Here."}
	anotherTestEntry := model.Task{Description:"Just messing with the project structure"}

	log.Print("Hello ",  testEntry.Description)
	log.Print("Hello Again and more. ",  anotherTestEntry.Description)

	// example on how to serve json...
	router.GET("/task/:id", func(c *gin.Context){
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
			c.JSON(http.StatusNotFound, model.Task{"", []string{}, ""});
		}
	})

	router.Run(":" + port)
}
