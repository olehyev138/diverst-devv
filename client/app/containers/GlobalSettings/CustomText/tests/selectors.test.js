import {
  selectCustomText, selectCustomTextDomain
} from 'containers/GlobalSettings/CustomText/selectors';

describe('CustomText selectors', () => {
  describe('selectCustomTextDomain', () => {
    it('should select the customText domain', () => {
      const mockedState = { customText: { custom_text: {} } };
      const selected = selectCustomTextDomain(mockedState);

      expect(selected).toEqual({ custom_text: {} });
    });
  });

  describe('selectCustomText', () => {
    it('should select the current customText', () => {
      const mockedState = { currentCustomText: { id: 32 } };
      const selected = selectCustomText().resultFunc(mockedState);

      expect(selected).toEqual({ id: 32 });
    });
  });
});
