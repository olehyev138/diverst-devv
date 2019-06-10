import { selectLocation } from 'containers/App/selectors';

xdescribe('selectLocation', () => {
  xit('should select the location', () => {
    const router = {
      location: { pathname: '/foo' },
    };
    const mockedState = {
      router,
    };

    expect(selectLocation()(mockedState)).toEqual(router.location);
  });
});
