<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="header flex flex-sb">
  <div class="backIco" onclick="history.back()">
    <i class="bi bi-arrow-left"></i>
  </div>
  <div style="display: flex; gap: 12px; align-items: center">
    <button
      id="darkmode-toggle"
      style="
        background: none;
        border: none;
        cursor: pointer;
        font-size: 20px;
        color: var(--color-black);
      "
    >
      <i class="bi bi-moon"></i>
    </button>
    <i class="bi bi-list" style="font-size: 20px"></i>
  </div>
</div>
