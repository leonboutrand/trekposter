import { saveAs } from 'file-saver';
import html2canvas from 'html2canvas';

const initDownloadImage = () => {
  const saveButton = document.querySelector('#save-button');
  if (saveButton) {
    saveButton.addEventListener('click', () => {
      document.querySelector("#map-container").style.transform = ""
      html2canvas(document.querySelector("#map-container")).then((canvas) => {
        canvas.toBlob((blob) => {
          saveAs(blob, "Map.png"); 
        });
      });
      document.querySelector("#map-container").style.transform = "scale(0.2)"
    })
  }
};

export { initDownloadImage };
