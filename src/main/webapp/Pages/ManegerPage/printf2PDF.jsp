<%@page import="model.BOs.CategoryBO"%>
<%@page import="model.entities.Category"%>
<%@page import="model.entities.Shop"%>
<%@page import="model.entities.Product"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShopeeFake</title>
<link rel="icon" type="image/x-icon" href="<%=request.getContextPath()%>/style/assets/images/logoShop/LogoWeb.png">
<style>
    body {
        font-family: Arial, sans-serif;
    }
    h2 {
        text-align: center;
    }
    table {
        width: 100%;
        border-collapse: collapse;
    }
    th, td {
        border: 1px solid #dddddd;
        text-align: left;
        padding: 8px;
    }
    th {
        background-color: #f2f2f2;
    }
    img {
        max-width: 100px;
        max-height: 100px;
    }
    button {
    display: block;
    width: 200px;
    margin: 20px auto;
    padding: 10px 20px;
    font-size: 16px;
    color: white;
    background-color: #007bff;
    border: none;
    border-radius: 5px;
    cursor: pointer;
	}
	
	button:hover {
	    background-color: #0056b3;
	}
</style>
</head>
<body>
	 <h2>Danh sách sản phẩm</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>Giá gốc</th>
                <th>Giá sale</th>
                <th>URL</th>
                <th>Ảnh</th>
                <th>Loại sản phẩm</th>
            </tr>
        </thead>
        <tbody>
            <% 
            ArrayList<Product> productList = (ArrayList<Product>) request.getAttribute("productList");
            if (productList != null) {
                for (Product product : productList) {
            %>
            <tr>
                <td><%= product.getId() %></td>
                <td><%= product.getFewChar() %></td>
                <td><%= Product.formMoney(product.getOriginalPrice()) %></td>
                <td><%= Product.formMoney(product.getSalePrice()) %></td>
                <td><%= product.getUrl() %></td>
                <td><img src="<%= product.getUrl() %>"></td>
                <td><%= CategoryBO.getCategory(product.getCategoryID()) %></td>
            </tr>
            <% 
                }
            }
            %>
        </tbody>
    </table>
    
    <button onclick="exportToPDF()" class="print-button">In PDF</button>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.3.2/html2canvas.min.js"></script>
    <script>
    function exportToPDF() {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();
        const margin = 10; // Đặt lề là 10 units
        const spacing = 5; // Khoảng cách giữa h2 và bảng

        Promise.all([
        	html2canvas(document.querySelector('h2')),
            html2canvas(document.querySelector('table'), { scale: 2, useCORS: true }) // Tăng độ phân giải của bảng và sử dụng CORS
        ]).then(function(canvases) {
            const h2Canvas = canvases[0];
            const tableCanvas = canvases[1];

            // Thêm tiêu đề h2 vào PDF với lề
            const h2ImgData = h2Canvas.toDataURL('image/png');
            const h2ImgProps = doc.getImageProperties(h2ImgData);
            const pdfWidth = doc.internal.pageSize.getWidth();
            const h2PdfHeight = (h2ImgProps.height * (pdfWidth - margin * 2)) / h2ImgProps.width;
            doc.addImage(h2ImgData, 'PNG', margin, margin, pdfWidth - margin * 2, h2PdfHeight);

            // Thêm bảng vào PDF với lề và khoảng cách từ h2
            const tableImgData = tableCanvas.toDataURL('image/png');
            const tableImgProps = doc.getImageProperties(tableImgData);
            const tablePdfHeight = (tableImgProps.height * (pdfWidth - margin * 2)) / tableImgProps.width;
            doc.addImage(tableImgData, 'PNG', margin, h2PdfHeight + margin + spacing, pdfWidth - margin * 2, tablePdfHeight);

            doc.save('CaiHoangLong_120123_WebShop_DanhSachSanPham.pdf');
        });
    }

    </script>
</body>
</html>