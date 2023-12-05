package com.consiti.dummyjson.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.consiti.dummyjson.entities.User;
import com.consiti.dummyjson.repositories.UserRepository;


@Service
@Transactional
public class UserService {
	@Autowired
	UserRepository userRepository;
	
	public void save(User user) {
		userRepository.save(user);
	}
	

}
