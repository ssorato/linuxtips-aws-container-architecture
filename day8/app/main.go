package main

import (
	"fmt"
	"log"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

func main() {
	app := fiber.New()

	app.Get("/version", func(c *fiber.Ctx) error {
		return c.SendString("v8")
	})

	app.Get("/healthcheck", func(c *fiber.Ctx) error {
		return c.SendString("ok")
	})

	app.Get("/files", func(c *fiber.Ctx) error {

		dir := "/mnt/efs"

		files, err := os.ReadDir(dir)
		if err != nil {
			log.Println(err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "Cannot read folder",
			})
		}

		var fileNames []string
		for _, file := range files {
			if !file.IsDir() {
				fileNames = append(fileNames, file.Name())
			}
		}
		return c.JSON(fiber.Map{
			"files": fileNames,
		})
	})

	app.Post("/files", func(c *fiber.Ctx) error {
		id := uuid.New()

		content := c.Body()

		dir := "/mnt/efs"
		filePath := fmt.Sprintf("%s/%s.txt", dir, id.String())

		err := os.WriteFile(filePath, content, 0644)
		if err != nil {
			log.Println(err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "Cannot write file",
			})
		}

		// Retorne uma resposta de sucesso
		return c.JSON(fiber.Map{
			"message": "File sucessful saved",
			"file":    filePath,
		})
	})

	app.Get("/files/:uuid", func(c *fiber.Ctx) error {
		id := c.Params("uuid")

		_, err := uuid.Parse(id)
		if err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error": "Invalid UUID",
			})
		}

		dir := "/mnt/efs"
		filePath := fmt.Sprintf("%s/%s.txt", dir, id)

		content, err := os.ReadFile(filePath)
		if err != nil {
			if os.IsNotExist(err) {
				return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
					"error": "File not found",
				})
			}
			log.Println(err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "Cannot read file",
			})
		}

		return c.SendString(string(content))
	})

	app.Get("/printenv", func(c *fiber.Ctx) error {
		return c.JSON(os.Environ())
	})

	_ = app.Listen(":8080")
}