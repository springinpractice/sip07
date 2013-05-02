/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch07.domain;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;

/**
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
@Entity
@Table(name = "forum")
@NamedQuery(
	name = "getForumsWithStats",
	query = "select forum, count(message), max(message.dateCreated)" +
		" from Forum as forum" +
		" left outer join forum.messages as message with message.visible = true" +
		" group by forum")
public class Forum {
	private Long id;
	private String name;
	private Account owner;
	private List<Message> messages = new ArrayList<Message>();
	
	// Stats fields
	private boolean calculateMessageStats = true;
	private int numVisibleMessages;
	private Date lastVisibleMessageDate;
	
	public Forum() { }
	
	public Forum(Long id) { this.id = id; }
	
	public Forum(Forum orig) {
		this.id = orig.id;
		this.name = orig.name;
		this.owner = orig.owner;
		this.messages = orig.messages;
		this.lastVisibleMessageDate = orig.lastVisibleMessageDate;
	}
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id")
	public Long getId() { return id; }
	
	@SuppressWarnings("unused")
	private void setId(Long id) { this.id = id; }
	
	@Column(name = "name")
	public String getName() { return name; }
	
	public void setName(String name) { this.name = name; }
	
	@ManyToOne
	@JoinColumn(name = "owner_id", nullable = false)
	public Account getOwner() { return owner; }
	
	public void setOwner(Account owner) { this.owner = owner; }
	
	@OneToMany(mappedBy = "forum")
	public List<Message> getMessages() { return messages; }
	
	public void setMessages(List<Message> messages) { this.messages = messages; }
	
	public void clearMessages() { messages.clear(); }
	
	@Transient
	public boolean getCalculateMessageStats() { return calculateMessageStats; }
	
	public void setCalculateMessageStats(boolean flag) {
		this.calculateMessageStats = flag;
	}

	@Transient
	public int getNumVisibleMessages() {
		if (calculateMessageStats) {
			int count = 0;
			for (Message message : messages) {
				if (message.isVisible()) { count++; }
			}
			return count;
		} else {
			return numVisibleMessages;
		}
	}
	
	public void setNumVisibleMessages(int n) {
		this.numVisibleMessages = n;
	}

	@Transient
	public Date getLastVisibleMessageDate() {
		if (calculateMessageStats) {
			Date date = null;
			for (Message message : messages) {
				if (message.isVisible()) {
					Date dateCreated = message.getDateCreated();
					if (date == null || date.compareTo(dateCreated) < 0) {
						date = message.getDateCreated();
					}
				}
			}
			return date;
		} else {
			return lastVisibleMessageDate;
		}
	}
	
	public void setLastVisibleMessageDate(Date date) {
		this.lastVisibleMessageDate = date;
	}
}
