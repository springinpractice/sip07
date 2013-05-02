/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch07.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

/**
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
@Entity
@Table(name = "message")
public class Message {
	private Long id;
	private Forum forum;
	private Account author;
	@NotNull @NotEmpty private String subject;
	@NotNull @NotEmpty private String text;
	private boolean visible = true;
	private Date dateCreated;
	
	public Message() { }
	
	public Message(Long id) { this.id = id; }
	
	public Message(Long forumId, Long messageId) {
		this.id = messageId;
		this.forum = new Forum(forumId);
	}
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id")
	public Long getId() { return id; }
	
	@SuppressWarnings("unused")
	private void setId(Long id) { this.id = id; }
	
	@ManyToOne
	@JoinColumn(name = "forum_id", nullable = false)
	public Forum getForum() { return forum; }
	
	public void setForum(Forum forum) { this.forum = forum; }
	
	@Column(name = "subject")
	public String getSubject() { return subject; }
	
	public void setSubject(String subject) { this.subject = subject; }
	
	@ManyToOne
	@JoinColumn(name = "author_id", nullable = false)
	public Account getAuthor() { return author; }
	
	public void setAuthor(Account author) { this.author = author; }
	
	@Column(name = "text")
	public String getText() { return text; }
	
	public void setText(String text) { this.text = text; }
	
	@Column(name = "visible")
	public boolean isVisible() { return visible; }
	
	public void setVisible(boolean visible) { this.visible = visible; }
	
	@Column(name = "date_created")
	public Date getDateCreated() { return dateCreated; }
	
	public void setDateCreated(Date date) { this.dateCreated = date; }
}
