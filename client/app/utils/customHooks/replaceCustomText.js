/*
  Replaces customText entries from given string
 */

import React, { useRef } from 'react';
import { useSelector } from 'react-redux';
import { selectCustomText } from '../../containers/Shared/App/selectors';

function replaceText(text, arr) {
  if (arr.length === 0)
    return text;
  const newText = text.replace(`{${arr[0][0]}}`, arr[0][1]);
  const newArr = arr.filter(param => param !== arr[0]);
  const res = replaceText(newText, newArr);
  return res;
}


function useCustomText(text) {
  const customTexts = useSelector(selectCustomText());
  return (text.includes('{') ? (replaceText(text, Object.entries(customTexts))) : (text));
}

export default useCustomText;
