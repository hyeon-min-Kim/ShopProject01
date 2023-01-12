<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- ${goodsList} --%>
<div class="productDiv">
	<ul>
		<c:forEach var="dto" items="${goodsList}" varStatus="status">
			<li>
				<a href="/details/${dto.gCode}" class="gimage">
					<img src="/resources/images/items/${dto.gImage}.gif" />
				</a>
				<p class="gname">${dto.gName}</p>
				<p class="gprice">${dto.gPrice}원</p>
				<p class="gcontent">${dto.gContent}</p>
			</li>
		</c:forEach>
	</ul>
</div>