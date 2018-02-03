package main

import (
	"log"
	"os"
	"github.com/gin-gonic/gin"
	"supertimemachine/service"
	"github.com/gin-contrib/cors"
	"flag"
)


func main() {
	port := os.Getenv("PORT")

	if port == "" {
		log.Fatal("$PORT must be set")
	}

	allowCors := flag.String("allowCORS", "", "Allow CORS");
	flag.Parse()

		// This is really messed up way of doing the initialization but will do for now.
	service.Data = service.InitTaskData()

	router := gin.New()

	if *allowCors != "" {
		log.Println("Allow CORS from: ", *allowCors)
		config := cors.DefaultConfig()
		config.AllowOrigins = []string{*allowCors}
		router.Use(cors.New(config))
	}

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
