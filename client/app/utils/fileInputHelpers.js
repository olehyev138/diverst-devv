import React from 'react';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'components/Shared/DiverstFileInput/messages';

const supportedFiles = {
  png: { type: 'image/png', message: <DiverstFormattedMessage {...messages.fileTypes.png} />, category: 'image' },
  jpg: { type: 'image/jpg', message: <DiverstFormattedMessage {...messages.fileTypes.jpg} />, category: 'image' },
  jpeg: { type: 'image/jpeg', message: <DiverstFormattedMessage {...messages.fileTypes.jpeg} />, category: 'image' },
  svg: { type: 'image/svg+xml', message: <DiverstFormattedMessage {...messages.fileTypes.svg} />, category: 'image' },
  gif: { type: 'image/gif', message: <DiverstFormattedMessage {...messages.fileTypes.gif} />, category: 'other' },
  pdf: { type: 'application/pdf', message: <DiverstFormattedMessage {...messages.fileTypes.pdf} />, category: 'other' },
  csv: { type: 'text/csv', message: <DiverstFormattedMessage {...messages.fileTypes.csv} />, category: 'other' },
  xml: { type: 'text/xml', message: <DiverstFormattedMessage {...messages.fileTypes.xml} />, category: 'other' },
  json: { type: 'application/json', message: <DiverstFormattedMessage {...messages.fileTypes.json} />, category: 'other' },
  zip: { type: 'application/zip', message: <DiverstFormattedMessage {...messages.fileTypes.zip} />, category: 'other' },
  plain: { type: 'text/plain', message: <DiverstFormattedMessage {...messages.fileTypes.plain} />, category: 'other' },
  html: { type: 'text/html', message: <DiverstFormattedMessage {...messages.fileTypes.html} />, category: 'other' },
};

export function getAllSupportedFileTypes() {
  return Object.values(supportedFiles).map(item => item.type);
}

export function getAllSupportedFileKeys() {
  return Object.keys(supportedFiles);
}

export function getAllSupportedFileMessages() {
  return Object.values(supportedFiles).map(item => item.message);
}

export function getSupportedImageFileTypes() {
  return Object.values(supportedFiles).filter(item => item.category === 'image').map(item => item.type);
}

export function getSupportedImageFileKeys() {
  return Object.keys(supportedFiles).filter(key => supportedFiles[key].category === 'image');
}

export function getSupportedImageFileMessages() {
  return Object.values(supportedFiles).filter(item => item.category === 'image').map(item => item.message);
}

export function getSupportedXMLFileTypes() {
  return Object.values(supportedFiles).filter(item => item.type === 'text/xml').map(item => item.type);
}

export function getSupportedXMLFileKeys() {
  return Object.keys(supportedFiles).filter(key => supportedFiles[key].type === 'text/xml');
}

export function getSupportedXMLFileMessages() {
  return Object.values(supportedFiles).filter(item => item.type === 'text/xml').map(item => item.message);
}
