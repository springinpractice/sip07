package com.springinpractice.ch07.dao;

import org.springframework.security.core.userdetails.UserDetailsService;

import com.springinpractice.ch07.domain.Account;
import com.springinpractice.dao.Dao;

public interface AccountDao extends Dao<Account>, UserDetailsService {
	
	Account getByUsername(String username);
}
