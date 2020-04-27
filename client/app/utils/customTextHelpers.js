import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import customTextMessages from 'containers/Shared/App/messages';
import dig from 'object-dig';

// Returns an object with all the custom texts, primarily used for passing arguments to intl messages
function customTexts(customText) {
  const customTexts = {};

  // eslint-disable-next-line no-return-assign
  Object.keys(customTextMessages.texts).forEach(
    (key, index) => {
      customTexts[key] = dig(customText, key) || intl.formatMessage(customTextMessages.texts[key]);
      customTexts[`${key}_p`] = dig(customText, 'plural', key) || intl.formatMessage(customTextMessages.plural_text[key]);
    }
  );

  return customTexts;
}

export { customTexts };
