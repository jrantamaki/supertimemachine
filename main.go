package main

import (
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"supertimemachine/service"
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

	router.GET("/task/", func(c *gin.Context){
		err, allTasks := service.GetAllTasks()
		if err != nil {
			c.JSON(http.StatusInternalServerError, "Could not get all tasks");
			return
		}
		c.JSON(http.StatusOK, allTasks)

	})

	router.GET("/task/:id", func(c *gin.Context){
		id :=  c.Param("id")
		i, err := strconv.Atoi(id)

		if err != nil { //FIXME there must be a better way to validate the parameter, that it is an int.
			c.JSON(http.StatusBadRequest, "id must be a number");
			return
		}

		e, task := service.GetTask(i)

		if e != nil {
			c.JSON(http.StatusBadRequest, e.Error())
			return
		}

		c.JSON(http.StatusOK, task);
	})

	router.POST("/task/", func(c *gin.Context){
		var task model.Task
		c.BindJSON(&task)
	
		c.JSON(http.StatusOK, task)
	})


	router.Run(":" + port)
}
