import { changePrimary, changeSecondary } from 'containers/Shared/ThemeProvider/actions';
import { CHANGE_PRIMARY, CHANGE_SECONDARY } from 'containers/Shared/ThemeProvider/constants';

describe('ThemeProvider actions', () => {
  describe('changePrimary', () => {
    it('has a type of CHANGE_PRIMARY and sets given colour', () => {
      const expected = {
        type: CHANGE_PRIMARY,
        color: 'color'
      };

      expect(changePrimary('color')).toEqual(expected);
    });
  });

  describe('changeSecondary', () => {
    it('has a type of CHANGE_SECONDARY and sets given colour', () => {
      const expected = {
        type: CHANGE_SECONDARY,
        color: 'color'
      };

      expect(changeSecondary('color')).toEqual(expected);
    });
  });
});
