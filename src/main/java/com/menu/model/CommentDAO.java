package com.menu.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;

public class CommentDAO extends SqlSessionDaoSupport {
	public void insert(CommentDTO commentDTO) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("board_num", commentDTO.getBoard_num());
		map.put("comment_num", commentDTO.getComment_num());

		getSqlSession().insert("inserComment", commentDTO);
		if (commentDTO.getComment_num() == 0)
			getSqlSession().update("updateCommentCount", map);
		else
			getSqlSession().update("updateReplyCount", map);
	}

	public List<CommentDTO> list(int board_num, int comment_num) {
		Map<String, Object> map = new HashMap<String, Object>();

		if (board_num != 0)
			map.put("board_num", board_num);
		map.put("comment_num", comment_num);

		return getSqlSession().selectList("commentList", map);
	}

	public void update(CommentDTO commentDTO) {
		getSqlSession().update("updateComment", commentDTO);
	}

	public void delete(int num, int board_num) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("board_num", board_num);

		getSqlSession().delete("deleteComment", num);
		getSqlSession().update("updateCommentCount", map);
	}

	public void deleteReply(int num, int comment_num) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("comment_num", comment_num);

		getSqlSession().delete("deleteComment", num);
		getSqlSession().update("updateReplyCount", map);
	}
}
