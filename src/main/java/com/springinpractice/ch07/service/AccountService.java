package com.springinpractice.ch07.service;

import com.springinpractice.ch07.domain.Account;

public interface AccountService {
	
	Account getAccountByUsername(String username);
}
