import { saveAs } from 'file-saver';
import html2canvas from 'html2canvas';

const initDownloadImage = () => {
  const saveButton = document.querySelector('#save-button');
  if (saveButton) {
    saveButton.addEventListener('click', () => {
      html2canvas(document.querySelector("#map-container")).then((canvas) => {
        canvas.toBlob((blob) => {
          saveAs(blob, "Map.png"); 
        });
      });
    })
  }
};

export { initDownloadImage };
