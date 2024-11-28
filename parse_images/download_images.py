import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

def download_images_from_url(url, save_folder):
    # 创建保存图像的文件夹
    if not os.path.exists(save_folder):
        os.makedirs(save_folder)

    # 获取网页内容
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    # 查找所有图像标签
    img_tags = soup.find_all('img')

    # 提取每个图像的URL并下载
    for index, img in enumerate(img_tags):
        img_url = img.get('data-src')
        # 处理相对URL
        img_url = urljoin(url, img_url)
        try:
            img_data = requests.get(img_url).content
            # 使用索引命名图像
            img_extension = os.path.splitext(img_url)[1] or '.jpg'  # 获取图像扩展名，默认为jpg
            img_name = f"{index}{img_extension}"  # 简化命名为数字+扩展名
            img_path = os.path.join(save_folder, img_name)
            with open(img_path, 'wb') as img_file:
                img_file.write(img_data)
            print(f"已下载: {img_path}")
        except Exception as e:
            print(f"下载失败 {img_url}: {e}")

# 使用示例

url = "https://mp.weixin.qq.com/s/0-jP3RvFuewh2E4imwRQ-A"
save_folder = "./zhongkong_tpt"

download_images_from_url(url, save_folder)