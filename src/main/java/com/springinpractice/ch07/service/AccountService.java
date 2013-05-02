/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch07.service;

import com.springinpractice.ch07.domain.Account;

/**
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
public interface AccountService {
	
	Account getAccountByUsername(String username);
}
