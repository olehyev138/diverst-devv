import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import customTextMessages from 'containers/Shared/App/messages';

// Returns an object with all the custom texts, primarily used for passing arguments to intl messages
function customTexts() {
  const customTexts = {};

  // eslint-disable-next-line no-return-assign
  Object.keys(customTextMessages).forEach((key, index) => customTexts[key] = intl.formatMessage(customTextMessages[key]));

  return customTexts;
}

export { customTexts };
