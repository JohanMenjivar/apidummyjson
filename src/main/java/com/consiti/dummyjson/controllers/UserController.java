package com.consiti.dummyjson.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.consiti.dummyjson.dto.Mensaje;
import com.consiti.dummyjson.dto.UserDto;
import com.consiti.dummyjson.services.UserService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.consiti.dummyjson.entities.User;



@RestController
@RequestMapping("/users")
@CrossOrigin(origins = "*")
public class UserController {

	@Autowired
	UserService userService;
	
	@PostMapping("")
	public ResponseEntity<Mensaje> create(@RequestBody String data) throws JsonProcessingException {
		User user = new User(data);
		userService.save(user);
		return new ResponseEntity<Mensaje>(new Mensaje("Registrado con exito!"), HttpStatus.CREATED);
}
}
