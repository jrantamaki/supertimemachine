package main

import (
	"log"
	"os"
	"github.com/gin-gonic/gin"
	"supertimemachine/service"
	"github.com/gin-contrib/cors"
	"flag"
	"gopkg.in/mgo.v2"
	"time"
)


func main() {
	// all this initialization logic should be set somewhere else.
	port := os.Getenv("PORT")
	mongoUrl := os.Getenv("MONGO_URL")
	mongoUser := os.Getenv("MONGO_USER")
	mongoPassword := os.Getenv("MONGO_PASSWORD")
	mongoDatabase := os.Getenv("MONGO_DATABASE")

	if port == "" {
		log.Fatal("$PORT must be set")
	}

	if mongoUrl == "" {
		log.Fatal("MONGO_URL must be set!")
	}

	if mongoUser == "" {
		log.Fatal("MONGO_USER must be set!")
	}

	if mongoPassword == "" {
		log.Fatal("MONGO_PASSWORD must be set!")
	}

	if mongoDatabase == "" {
		log.Fatal("MONGO_DATABASE must be set!")
	}


	allowCors := flag.String("allowCORS", "", "Allow CORS");
	flag.Parse()

	router := gin.New()

	if *allowCors != "" {
		log.Println("Allow CORS from: ", *allowCors)
		config := cors.DefaultConfig()
		config.AllowMethods = append(config.AllowMethods, "PATCH")
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
	router.PATCH("/task/:id", service.TaskPatchHandler)
	router.POST("/task/", service.AddNewTaskHandler)


	dialInfo := mgo.DialInfo{
		Username:mongoUser,
		Password:mongoPassword,
		Addrs:[]string{mongoUrl},
		Database: mongoDatabase,
		Timeout:10*time.Second,
	}
	session, err := mgo.DialWithInfo(&dialInfo)

	if err != nil {
		log.Fatal("Cannot Dial Mongo: ", err)
	}

	session.SetMode(mgo.Monotonic, true)
	defer session.Close()

	service.Session = session

	log.Println("Started the mongo connection! ")


	router.Run(":" + port)
}
