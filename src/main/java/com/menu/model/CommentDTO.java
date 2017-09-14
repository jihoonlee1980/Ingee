package com.menu.model;

import java.sql.Timestamp;

import org.springframework.web.multipart.MultipartFile;

public class CommentDTO {
	int num, board_num, comment_num, reply_count;
	String writer, content, id, origin_filename, saved_filename;
	Timestamp writetime;
	MultipartFile upload_file;

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public int getBoard_num() {
		return board_num;
	}

	public void setBoard_num(int board_num) {
		this.board_num = board_num;
	}

	public int getComment_num() {
		return comment_num;
	}

	public void setComment_num(int comment_num) {
		this.comment_num = comment_num;
	}

	public int getReply_count() {
		return reply_count;
	}

	public void setReply_count(int reply_count) {
		this.reply_count = reply_count;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getOrigin_filename() {
		return origin_filename;
	}

	public void setOrigin_filename(String origin_filename) {
		this.origin_filename = origin_filename;
	}

	public String getSaved_filename() {
		return saved_filename;
	}

	public void setSaved_filename(String saved_filename) {
		this.saved_filename = saved_filename;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Timestamp getWritetime() {
		return writetime;
	}

	public void setWritetime(Timestamp writetime) {
		this.writetime = writetime;
	}

	public MultipartFile getUpload_file() {
		return upload_file;
	}

	public void setUpload_file(MultipartFile upload_file) {
		this.upload_file = upload_file;
	}
}
