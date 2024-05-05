package controllers;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.BOs.CategoryBO;
import model.BOs.ProductBO;
import model.entities.Product;
import model.entities.Shop;

@WebServlet("/Trangchu/printf2PDF")
public class printf2PDFServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // Lấy dữ liệu cần thiết cho trang JSP
        HttpSession session = request.getSession();
        Shop shop = (Shop) session.getAttribute("shop");
        ArrayList<Product> productList = ProductBO.getProductsByShop(shop.getId());
        request.setAttribute("productList", productList);
        request.setAttribute("categoryList", CategoryBO.getCategorysInData());

        // Điều hướng đến trang JSP để hiển thị giao diện cho việc in thành tệp PDF
        RequestDispatcher dispatcher = request.getRequestDispatcher("/Pages/ManegerPage/printf2PDF.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Điều hướng lại đến phương thức doGet để hiển thị giao diện trước khi in thành tệp PDF
        doGet(request, response);
    }
}