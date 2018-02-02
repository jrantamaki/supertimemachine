package main

import (
	"log"
	"os"
	"flag"
	"github.com/gin-gonic/gin"
	"github.com/gin-contrib/cors"
	"supertimemachine/service"
)


func main() {
	port := os.Getenv("PORT")

	if port == "" {
		log.Fatal("$PORT must be set")
	}

	var allowCors = flag.String("allowCORS","","CORS allowed for given url")

	// This is really messed up way of doing the initialization but will do for now.
	service.Data = service.InitTaskData()

	router := gin.New()
	router.Use(gin.Logger())
	router.LoadHTMLGlob("templates/*.tmpl.html")
	router.Static("/static", "../elm-client/dist/static")

	router.GET("/", func(c *gin.Context) {
		c.File("../elm-client/dist/index.html")
	})

	router.GET("/task/", service.GetAllTasksHandler)
	router.GET("/task/:id", service.GetTaskHandler)
	router.POST("/task/", service.AddNewTaskHandler)

	router.Run(":" + port)
}
