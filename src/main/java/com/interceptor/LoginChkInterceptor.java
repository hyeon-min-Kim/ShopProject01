package com.interceptor;

import java.net.URI;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UrlPathHelper;

public class LoginChkInterceptor extends HandlerInterceptorAdapter {
	/*- preHandle() : Controller 작업 전
	- postHandle() : Controller 작업 후
	- afterCompletion() : Controller와 View 작업 후
	*/

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		//servlet-context.xml에 빈 생성 후 인터셉터 매핑주소 등록.
		HttpSession session = request.getSession();
		if(session.getAttribute("login") == null){
			System.out.println("LoginChkInterceptor 로그아웃 상태");
			String prevPage = new URI(request.getHeader("Referer")).getPath();
			System.out.println("interceptor prevPAge : "+prevPage);
			
			//[참고]https://hihoyeho.tistory.com/entry/HttpServletRequest-%ED%95%A8%EC%88%98%EB%A5%BC-%EC%82%AC%EC%9A%A9%ED%95%9C-%EC%9A%94%EC%B2%AD-URL-%EC%B7%A8%EB%93%9D
//			String url = request.getRequestURI(); //컨텍스트 경로+서블릿 경로
//			String query = request.getQueryString(); //?뒤의 쿼리
//			UrlPathHelper urlPathHelper = new UrlPathHelper(); // 패키지 경로 알아내기 : org.springframework.web.util.UrlPathHelper&nbsp;
//			String originalURL = urlPathHelper.getOriginatingRequestUri(request);
			//System.out.println("url"+url);
			//System.out.println("originalURL"+originalURL);
			
			//**redirect - request로 로그인페이지에 메세지를 전달할 수 없다.
			//response.sendRedirect(request.getContextPath() + "/loginForm"); //절대경로 사용. @RequestMapping(value="/loginForm", method = RequestMethod.GET)
			//http://localhost:8081/company/loginForm
			//response.sendRedirect("../loginForm"); //상대경로 사용.  /company/loginChk에서 상위폴더 /company로 가서 그 하위의 /loginForm으로 이동.
			
			//**forward
			//안됨. 포워드로 요청하면 로그인 후 Request method 'POST' not supported 405에러 뜬다.
			//RequestDispatcher requestDispatcher = request.getRequestDispatcher(request.getContextPath() + "/loginForm");
			//requestDispatcher.forward(request, response);
			//request.getRequestDispatcher("/loginForm").forward(request, response); //다른 방법.
			
			//**Model객체 사용.
			//안됨. Model객체를 매개변수로 받아야 하는데, 매개변수 추가하면 preHandle메소드가 아예 안탐.
			
			//**ModelAndView사용
			//[참고]
			//https://npre.tistory.com/20
			//https://stove99.github.io/java/2019/05/02/spring-boot-interceptor-forward//loginForm
			ModelAndView mav = new ModelAndView("viewer/loginFormView");
            mav.addObject("mesg", "로그인 후 이용해주세요.");
            //mav.addObject("nextPage", originalURL);
            
            throw new ModelAndViewDefiningException(mav); 
            //로그인폼 서브밋 시 =->preHandle메소드실행. 무한으로 돈다. 
            //=>로그인 폼에서 서브밋시 요청을 절대경로로 줘야 함. 상대경로로주면 /loginChk요청이 다시 들어가서 preHandle메소드가 계속 실행되었던 것. 
            
			
			//return false;
		}else {
			System.out.println("LoginChkInterceptor 로그인 상태");
			return super.preHandle(request, response, handler);
		}
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		super.postHandle(request, response, handler, modelAndView);
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		super.afterCompletion(request, response, handler, ex);
	}

	@Override
	public void afterConcurrentHandlingStarted(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		super.afterConcurrentHandlingStarted(request, response, handler);
	}

}
