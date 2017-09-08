package com.menu.model;

import org.mybatis.spring.support.SqlSessionDaoSupport;

public class CommentDAO extends SqlSessionDaoSupport {
	public void insert(CommentDTO commentDTO) {
		getSqlSession().insert("inserComment", commentDTO);
		getSqlSession().update("updateCommentCount", commentDTO.getBoard_num());
	}
}
