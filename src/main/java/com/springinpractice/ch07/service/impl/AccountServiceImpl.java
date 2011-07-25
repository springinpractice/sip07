package com.springinpractice.ch07.service.impl;

import javax.inject.Inject;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springinpractice.ch07.dao.AccountDao;
import com.springinpractice.ch07.domain.Account;
import com.springinpractice.ch07.service.AccountService;

/**
 * Basic {@link AccountService} implementation.
 * 
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
@Service
@Transactional
@PreAuthorize("denyAll")
public class AccountServiceImpl implements AccountService {
	@Inject private AccountDao accountDao;

	/* (non-Javadoc)
	 * @see com.springinpractice.ch07.service.AccountService#getAccountByUsername(java.lang.String)
	 */
	@PreAuthorize("hasRole('PERM_READ_ACCOUNTS')")
	public Account getAccountByUsername(String username) {
		return accountDao.getByUsername(username);
	}
}
