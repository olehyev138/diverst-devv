xdescribe('Landing actions', () => {
  xdescribe('Default Action', () => {
    xit('has a type of DEFAULT_ACTION', () => {
      const expected = {
        type: DEFAULT_ACTION,
      };
      expect(defaultAction()).toEqual(expected);
    });
  });
});
