import { selectTheme, makeSelectPrimary, makeSelectSecondary } from 'containers/Shared/ThemeProvider/selectors';

describe('ThemeProvider selectors', () => {
  describe('selectTheme', () => {
    it('should select the theme state domain', () => {
      const mockedState = { theme: {} };
      const selected = selectTheme(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('makeSelectPrimary', () => {
    it('should select the primary color', () => {
      const mockedState = { primary: 'primary' };
      const selected = makeSelectPrimary().resultFunc(mockedState);

      expect(selected).toEqual('primary');
    });
  });

  describe('makeSelectSecondary', () => {
    it('should select the secondary color', () => {
      const mockedState = { secondary: 'secondary' };
      const selected = makeSelectSecondary().resultFunc(mockedState);

      expect(selected).toEqual('secondary');
    });
  });
});
