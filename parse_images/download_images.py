import requests
from bs4 import BeautifulSoup
import os
from urllib.parse import urljoin, urlparse
from tqdm import tqdm
import re

class ImageDownloader:
    def __init__(self, save_dir='images'):
        self.save_dir = save_dir
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        self.create_save_dir()
        
    def create_save_dir(self):
        """创建保存目录"""
        if not os.path.exists(self.save_dir):
            os.makedirs(self.save_dir)
    
    def is_valid_image_url(self, url):
        """检查URL是否是有效的图片链接"""
        image_extensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.svg']
        parsed_url = urlparse(url)
        return any(parsed_url.path.lower().endswith(ext) for ext in image_extensions)
    
    def get_image_urls(self, soup):
        """获取页面中所有可能的图片URL"""
        image_urls = set()
        
        # 1. 查找所有 img 标签
        for img in soup.find_all('img'):
            # 检查 src 属性
            src = img.get('src')
            if src:
                image_urls.add(src)
            # 检查 data-src 属性（懒加载）
            data_src = img.get('data-src')
            if data_src:
                image_urls.add(data_src)
            # 检查 srcset 属性
            srcset = img.get('srcset')
            if srcset:
                urls = srcset.split(',')
                for url in urls:
                    image_urls.add(url.split()[0])
        
        # 2. 查找背景图片
        for elem in soup.find_all(style=True):
            style = elem['style']
            urls = re.findall(r'url\(["\']?(.*?)["\']?\)', style)
            image_urls.update(urls)
        
        # 3. 查找 a 标签中的图片链接
        for a in soup.find_all('a', href=True):
            if self.is_valid_image_url(a['href']):
                image_urls.add(a['href'])
        
        return image_urls
    
    def download_image(self, img_url, base_url):
        """下载单个图片"""
        try:
            # 确保URL是完整的
            img_url = img_url.strip()
            if not img_url:
                return False
                
            img_url = urljoin(base_url, img_url)
            
            # 检查URL是否有效
            if not self.is_valid_image_url(img_url):
                return False
            
            # 获取文件名
            img_name = os.path.basename(urlparse(img_url).path)
            if not img_name or '.' not in img_name:
                img_name = f"image_{hash(img_url)}.jpg"
            
            # 检查文件是否已存在
            file_path = os.path.join(self.save_dir, img_name)
            if os.path.exists(file_path):
                print(f"File already exists: {img_name}")
                return True
            
            # 下载图片
            response = requests.get(img_url, headers=self.headers, stream=True, timeout=10)
            response.raise_for_status()
            
            # 检查内容类型
            content_type = response.headers.get('content-type', '')
            if not content_type.startswith('image/'):
                return False
            
            # 保存图片
            with open(file_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    if chunk:
                        f.write(chunk)
            
            return True
            
        except Exception as e:
            print(f"Error downloading {img_url}: {str(e)}")
            return False
    
    def download_all_images(self, url):
        """下载页面中的所有图片"""
        try:
            # 获取页面内容
            response = requests.get(url, headers=self.headers)
            response.raise_for_status()
            
            # 使用正确的编码
            response.encoding = response.apparent_encoding
            soup = BeautifulSoup(response.text, 'html.parser')
            
            # 获取所有图片URL
            image_urls = self.get_image_urls(soup)
            
            # 下载图片
            success_count = 0
            with tqdm(total=len(image_urls), desc="Downloading images") as pbar:
                for img_url in image_urls:
                    if self.download_image(img_url, url):
                        success_count += 1
                    pbar.update(1)
            
            print(f"\nDownload completed! Successfully downloaded {success_count} out of {len(image_urls)} images.")
            
        except Exception as e:
            print(f"Error: {str(e)}")

# 使用示例
if __name__ == "__main__":
    url = "https://example.com"
    downloader = ImageDownloader("downloaded_images")
    downloader.download_all_images(url)