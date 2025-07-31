#กรุณาอ่านก่อนทำการติดตั้ง 
https://github.com/RealHard23/VTEC_Dynamic/blob/main/README.md

#V4.8.1
บันทึกการเปลี่ยนแปลง
ลบโค้ดที่่คาดว่าอาจจะทำให้่เกิดปัญหา bootloop (บางรุ่น)
 #Fix delete code dynamic stune / schedutil input-boost -------
echo 0 > /sys/module/cpu_input_boost/parameters/enabled 2>/dev/null
echo 0 > /sys/module/dsboost/parameters/enabled 2>/dev/null
echo 0 > /sys/module/dsboost/parameters/input_boost_ms 2>/dev/null
echo 0 > /sys/module/cpu_boost/parameters/input_boost_ms 2>/dev/null


#สำคัญ โมดูลมาจิกไม่ใช่สิ่งวิเศษที่จะทำให้โทรศัพท์ของคุณเปลี่ยนเป็นรุ่นที่ใหม่กว่าได้ ความสามารถจะถูกจำกัดเฉพาะรุ่นต่อรุ่นเท่านั้น ตามกำลังที่ CPU สามารถจะทำได้แค่นั้น เพราะฉะนั้นอย่าหลอน
#โค้ดทุกบรรทัดและคำอธิบายหลักการทำงาน มาจาก AI 100% ไม่ได้มโนขึ้นมาเอง เพราะฉะนั้นถ้าเกิดกรณี บัค bootloop brick ให้โทษตัวเองแล้วก็โทษตัว AI ได้เลย นะจ๊ะ คำเตือนมีให้อ่านเพราะฉะนั้นอ่านด้วยครับ