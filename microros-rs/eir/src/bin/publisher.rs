#![no_std]
#![no_main]
#![feature(type_alias_impl_trait)]

use defmt::*;
use eir::microros;
use eir::microros::Allocator;
use eir::microros::RclNode;
use eir::microros::RclPublisher;
use eir::microros::RclcExecutor;
use eir::microros::RclcSupport;
use embassy_executor::InterruptExecutor;
use embassy_executor::Spawner;
use embassy_futures::yield_now;
use embassy_rp::gpio;
use embassy_rp::interrupt;
use embassy_rp::interrupt::InterruptExt as _;
use embassy_rp::interrupt::Priority;
use embassy_rp::Peripherals;
use embassy_time::Timer;
use gpio::{Level, Output};
use microros_sys::rosidl_typesupport_c__get_message_type_support_handle__std_msgs__msg__Int32;
use microros_sys::std_msgs__msg__Int32__create;
use {defmt_rtt as _, panic_probe as _};

#[embassy_executor::task]
async fn run_embassy(p: Peripherals) {
    defmt::info!("hello");
    let spawner = Spawner::for_current_executor().await;

    eir::transport::init_usb_transport(p.USB, &spawner).await;

    let mut led = Output::new(p.PIN_20, Level::Low);
    loop {
        led.set_high();
        Timer::after_millis(300).await;
        led.set_low();
        Timer::after_millis(300).await;
    }
}

static EXECUTOR_EMBASSY: InterruptExecutor = InterruptExecutor::new();

#[interrupt]
unsafe fn SWI_IRQ_0() {
    EXECUTOR_EMBASSY.on_interrupt()
}

#[embassy_executor::main]
async fn main(spawner: Spawner) {
    let p = embassy_rp::init(Default::default());

    interrupt::SWI_IRQ_0.set_priority(Priority::P3);
    let embassy_spawner = EXECUTOR_EMBASSY.start(interrupt::SWI_IRQ_0);
    unwrap!(embassy_spawner.spawn(run_embassy(p)));

    Timer::after_secs(1).await;

    eir::transport::init_rmw_transport();

    let mut allocator = Allocator::default();

    microros::wait_for_agent();

    let mut support = RclcSupport::new(&mut allocator);
    let mut node = RclNode::new("pico_node", "", &mut support);
    let publisher = RclPublisher::new(
        &mut node,
        unsafe { rosidl_typesupport_c__get_message_type_support_handle__std_msgs__msg__Int32() },
        "pico_publisher",
    );
    defmt::unwrap!(spawner.spawn(publisher_task(publisher)));

    let mut executor = RclcExecutor::new(&mut support, 10, &mut allocator);

    loop {
        yield_now().await;
        executor.spin();
    }
}

#[embassy_executor::task]
async fn publisher_task(mut publisher: RclPublisher) {
    let a = unsafe { std_msgs__msg__Int32__create() };
    loop {
        Timer::after_millis(1000).await;
        publisher.publish(a as _);
        unsafe { (*a).data += 1 };
    }
}
