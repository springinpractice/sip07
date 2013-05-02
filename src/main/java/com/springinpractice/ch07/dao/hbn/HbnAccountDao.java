/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch07.dao.hbn;

import static org.springframework.util.Assert.notNull;

import org.springframework.dao.DataAccessException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.springinpractice.ch07.dao.AccountDao;
import com.springinpractice.ch07.domain.Account;
import com.springinpractice.dao.hibernate.AbstractHbnDao;

/**
 * Hibernate-based {@link AccountDao} implementation.
 * 
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
@Repository("accountDao")
public class HbnAccountDao extends AbstractHbnDao<Account> implements AccountDao {
	
	/* (non-Javadoc)
	 * @see com.springinpractice.ch07.dao.AccountDao#getByUsername(java.lang.String)
	 */
	@Override
	public Account getByUsername(String username) {
		notNull(username, "username can't be null");
		return (Account) getSession()
			.getNamedQuery("account.byUsername")
			.setParameter("username", username)
			.uniqueResult();
	}
	
	/* (non-Javadoc)
	 * @see org.springframework.security.core.userdetails.UserDetailsService#loadUserByUsername(java.lang.String)
	 */
	@Override
	@Transactional
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException, DataAccessException {
		notNull(username, "username can't be null");
		Account account = getByUsername(username);
		if (account == null) {
			throw new UsernameNotFoundException("No user with username " + username);
		}
		return account;
	}
}
