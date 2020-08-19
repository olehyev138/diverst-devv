import React from 'react';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'components/Shared/DiverstFileInput/messages';

const supportedFiles = {
  png: { type: 'image/png', message: <DiverstFormattedMessage {...messages.fileTypes.png} /> },
  jpg: { type: 'image/jpg', message: <DiverstFormattedMessage {...messages.fileTypes.jpg} /> },
  jpeg: { type: 'image/jpeg', message: <DiverstFormattedMessage {...messages.fileTypes.jpeg} /> },
  svg: { type: 'image/svg', message: <DiverstFormattedMessage {...messages.fileTypes.svg} /> },
  gif: { type: 'image/gif', message: <DiverstFormattedMessage {...messages.fileTypes.gif} /> },
  pdf: { type: 'application/pdf', message: <DiverstFormattedMessage {...messages.fileTypes.pdf} /> },
  csv: { type: 'text/csv', message: <DiverstFormattedMessage {...messages.fileTypes.csv} /> },
  xml: { type: 'text/xml', message: <DiverstFormattedMessage {...messages.fileTypes.xml} /> },
  json: { type: 'application/json', message: <DiverstFormattedMessage {...messages.fileTypes.json} /> },
  zip: { type: 'application/zip', message: <DiverstFormattedMessage {...messages.fileTypes.zip} /> },
  plain: { type: 'text/plain', message: <DiverstFormattedMessage {...messages.fileTypes.plain} /> },
  html: { type: 'text/html', message: <DiverstFormattedMessage {...messages.fileTypes.html} /> },
};
const supportedImageFiles = {
  png: { type: 'image/png', message: <DiverstFormattedMessage {...messages.fileTypes.png} /> },
  jpg: { type: 'image/jpg', message: <DiverstFormattedMessage {...messages.fileTypes.jpg} /> },
  jpeg: { type: 'image/jpeg', message: <DiverstFormattedMessage {...messages.fileTypes.jpeg} /> },
  svg: { type: 'image/svg', message: <DiverstFormattedMessage {...messages.fileTypes.svg} /> },
};

export function getAllSupportedFileTypes() {
  return Object.values(supportedFiles).map(obj => obj.type);
}

export function getAllSupportedFileKeys() {
  return Object.keys(supportedFiles);
}

export function getSupportedImageFileTypes() {
  return Object.values(supportedImageFiles).map(obj => obj.type);
}

export function getSupportedImageFileKeys() {
  return Object.keys(supportedImageFiles);
}

export function getFileMessages(fileType) {
  return supportedFiles[fileType].message;
}
